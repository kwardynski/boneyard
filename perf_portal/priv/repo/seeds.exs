# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PerfPortal.Repo.insert!(%PerfPortal.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto.Query

alias PerfPortal.Repo

alias PerfPortal.Assets.Pad
alias PerfPortal.Assets.Well
alias PerfPortal.Clients.Company
alias PerfPortal.Completions.Cluster
alias PerfPortal.Completions.Perforation
alias PerfPortal.Completions.Stage

defmodule Randomization do
  @depth_randomization 0.05
  @phase_randomization 5

  def depth(depth) do
    max = @depth_randomization
    min = -@depth_randomization

    depth
    |> parse_from_string()
    |> Kernel.+(calculate_randomization_offset(max, min))
    |> Float.round(2)
  end

  def phase(phase) do
    max = @phase_randomization
    min = -@phase_randomization

    phase
    |> parse_from_string()
    |> Kernel.+(calculate_randomization_offset(max, min))
    |> handle_phase_periodicity()
    |> Float.round(2)
  end

  defp parse_from_string(string) do
    {float, _} = Float.parse(string)
    float
  end

  defp calculate_randomization_offset(max, min), do: :rand.uniform() * (max - min) + min

  defp handle_phase_periodicity(phase) when phase < 0, do: 360 + phase
  defp handle_phase_periodicity(phase) when phase > 360, do: phase - 360
  defp handle_phase_periodicity(phase), do: phase
end

if Mix.env() == :dev do
  company_attrs = %{name: "Northern Oil Corp"}

  %Company{id: company_id} =
    company_attrs
    |> Company.create_changeset()
    |> Repo.insert!()

  pad_attrs = %{name: "Noc Permian West 2", company_id: company_id}

  %Pad{id: pad_id} =
    pad_attrs
    |> Pad.create_changeset()
    |> Repo.insert!()

  well_names = ["NOC PW2-1", "NOC PW2-2"]

  for well_name <- well_names do
    well_attrs = %{
      name: well_name,
      company_id: company_id,
      pad_id: pad_id
    }

    %Well{id: well_id} =
      well_attrs
      |> Well.create_changeset()
      |> Repo.insert!()

    perforation_csv_path = "priv/repo/seed_files/#{well_name}.csv"

    [header_row | perforation_rows] =
      perforation_csv_path
      |> File.read!()
      |> String.trim()
      |> String.split("\n")

    header = String.split(header_row, ",")

    perforation_rows
    |> Enum.map(fn perforation_row ->
      perforations = String.split(perforation_row, ",")
      Enum.zip(header, perforations) |> Enum.into(%{})
    end)
    |> Enum.each(fn perforation ->
      stage_name = perforation["stage"]

      stage_query =
        from(s in Stage,
          where: s.name == ^stage_name,
          where: s.well_id == ^well_id
        )

      %{id: stage_id} =
        if Repo.exists?(stage_query),
          do: Repo.one(stage_query),
          else:
            %{name: stage_name, well_id: well_id}
            |> Stage.create_changeset()
            |> Repo.insert!()

      cluster_name = perforation["cluster"]

      cluster_query =
        from(c in Cluster,
          where: c.name == ^cluster_name,
          where: c.stage_id == ^stage_id
        )

      %{id: cluster_id} =
        if Repo.exists?(cluster_query),
          do: Repo.one(cluster_query),
          else:
            %{name: cluster_name, stage_id: stage_id}
            |> Cluster.create_changeset()
            |> Repo.insert!()

      %{
        name: "#{stage_name}.#{cluster_name}.#{perforation["perf"]}",
        cluster_id: cluster_id,
        depth: Randomization.depth(perforation["depth"]),
        phase: Randomization.phase(perforation["phase"]),
        exit_diameter: perforation["exit_diameter"],
        exit_diameter_increase: perforation["exit_diameter_increase"]
      }
      |> Perforation.create_changeset()
      |> Repo.insert!()
    end)
  end
end
