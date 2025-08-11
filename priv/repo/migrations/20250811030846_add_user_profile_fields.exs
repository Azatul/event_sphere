defmodule EventSphere.Repo.Migrations.AddUserProfileFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :full_name, :string
      add :department, :string
      add :ic_number, :string
      add :position, :string
      add :dob, :date
      add :gender, :string
      add :appointment_date, :date
      add :job_status, :string
      add :phone, :string
      add :marital_status, :string
      add :address, :text
      add :profile_photo_url, :string
    end

    create unique_index(:users, [:ic_number])
  end
end
