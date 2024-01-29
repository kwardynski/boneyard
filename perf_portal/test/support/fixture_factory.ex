defmodule PerfPortal.FixtureFactory do
  @moduledoc false

  alias PerfPortal.AssetsFixtures
  alias PerfPortal.ClientsFixtures
  alias PerfPortal.CompletionsFixtures

  def create_company(_) do
    company = ClientsFixtures.company_fixture(%{})
    %{company: company}
  end

  def create_pad(%{company: company}) do
    pad = AssetsFixtures.pad_fixture(company)
    %{pad: pad}
  end

  def create_well(%{pad: pad}) do
    well = AssetsFixtures.well_fixture(pad)
    %{well: well}
  end

  def create_stage(%{well: well}) do
    stage = CompletionsFixtures.stage_fixture(well)
    %{stage: stage}
  end

  def create_cluster(%{stage: stage}) do
    cluster = CompletionsFixtures.cluster_fixture(stage)
    %{cluster: cluster}
  end

  def create_perforation(%{cluster: cluster}) do
    perforation = CompletionsFixtures.perforation_fixture(cluster)
    %{perforation: perforation}
  end
end
