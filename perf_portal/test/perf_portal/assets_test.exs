defmodule PerfPortal.AssetsTest do
  use PerfPortal.DataCase

  import PerfPortal.AssetsFixtures
  import PerfPortal.FixtureFactory

  alias PerfPortal.Assets
  alias PerfPortal.Assets.Pad
  alias PerfPortal.Assets.Well

  describe "pads" do
    @invalid_attrs %{name: nil}

    setup [
      :create_company,
      :create_pad
    ]

    test "list_pads/0 returns all pads", %{pad: pad} do
      assert Assets.list_pads() == [pad]
    end

    test "get_pad!/1 returns the pad with given id", %{pad: pad} do
      assert Assets.get_pad!(pad.id) == pad
    end

    test "create_pad/1 with valid data creates a pad", %{company: company} do
      valid_attrs = %{name: "PadName"}

      assert {:ok, %Pad{} = pad} = Assets.create_pad(company, valid_attrs)
      assert pad.name == "PadName"
      assert pad.company_id == company.id
    end

    test "create_pad/1 with invalid data returns error changeset", %{company: company} do
      assert {:error, %Ecto.Changeset{}} = Assets.create_pad(company, @invalid_attrs)
    end

    test "update_pad/2 with valid data updates the pad", %{pad: pad, company: company} do
      update_attrs = %{name: "some updated name"}
      assert {:ok, %Pad{} = pad} = Assets.update_pad(pad, update_attrs)
      assert pad.name == "some updated name"
      assert pad.company_id == company.id
    end

    test "update_pad/2 with invalid data returns error changeset", %{pad: pad} do
      assert {:error, %Ecto.Changeset{}} = Assets.update_pad(pad, @invalid_attrs)
      assert pad == Assets.get_pad!(pad.id)
    end

    test "delete_pad/1 deletes the pad", %{company: company} do
      pad = pad_fixture(company)
      assert {:ok, %Pad{}} = Assets.delete_pad(pad)
      assert_raise Ecto.NoResultsError, fn -> Assets.get_pad!(pad.id) end
    end
  end

  describe "wells" do
    @invalid_attrs %{name: nil}

    setup [
      :create_company,
      :create_pad,
      :create_well
    ]

    test "list_wells/0 returns all wells", %{well: well} do
      assert Assets.list_wells() == [well]
    end

    test "get_well!/1 returns the well with given id", %{well: well} do
      assert Assets.get_well!(well.id) == well
    end

    test "create_well/1 with valid data creates a well", %{company: company, pad: pad} do
      valid_attrs = %{name: "WellName"}

      assert {:ok, %Well{} = well} = Assets.create_well(pad, valid_attrs)
      assert well.name == "WellName"
      assert well.company_id == company.id
      assert well.pad_id == pad.id
    end

    test "create_well/1 with invalid data returns error changeset", %{pad: pad} do
      assert {:error, %Ecto.Changeset{}} = Assets.create_well(pad, @invalid_attrs)
    end

    test "update_well/2 with valid data updates the well", %{
      well: well,
      company: company,
      pad: pad
    } do
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Well{} = well} = Assets.update_well(well, update_attrs)
      assert well.name == "some updated name"
      assert well.company_id == company.id
      assert well.pad_id == pad.id
    end

    test "update_well/2 with invalid data returns error changeset", %{well: well} do
      assert {:error, %Ecto.Changeset{}} = Assets.update_well(well, @invalid_attrs)
      assert well == Assets.get_well!(well.id)
    end

    test "delete_well/1 deletes the well", %{pad: pad} do
      well = well_fixture(pad)
      assert {:ok, %Well{}} = Assets.delete_well(well)
      assert_raise Ecto.NoResultsError, fn -> Assets.get_well!(well.id) end
    end
  end
end
