class Project < ActiveRecord::Base
  belongs_to :tenant

  # Project title must be unique
  validates_uniqueness_of :title, message: "is being used by another project. Please specify another name."
  validates_presence_of :title, message: "can't be empty"
  validates_presence_of :details, message: "can't be empty"
  validates_presence_of :expected_completion_date, message: "can't be empty"

  # Free plan can only create one project
  validate :free_plan_can_have_only_one_project

  def free_plan_can_have_only_one_project
    if self.new_record? && !tenant.can_create_more_projects?
      errors.add :base, "Free plans cannot have more than one project"
    end
  end

  # This method will be removed later
  def self.by_plan_and_tenant(tenant_id)
    tenant = Tenant.find_by(id: tenant_id)

    if tenant.plan == Plan::PLAN_PREMIUM
      return tenant.projects
    else
      return tenant.projects.order(:id).limit(1)
    end
  end
end
