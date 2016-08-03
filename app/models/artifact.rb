class Artifact < ActiveRecord::Base
  MAX_FILE_SIZE = 10.megabytes

  before_save :upload_file_to_amazon_s3

  attr_accessor :file
  belongs_to :project
  validates_uniqueness_of :name
  validates_presence_of :name, :file

  validate :max_upload_file_size

  private

  def upload_file_to_amazon_s3
    s3 = Aws::S3::Resource.new
    tenant_name = self.project.tenant.name
    obj = s3.bucket(ENV['AWS_S3_BUCKET_PM_APP']).object(Rails.env + "/" + tenant_name + "/" + file.original_filename)
    obj.upload_file(file.path, acl: "public-read")
    self.key = obj.public_url
  end

  def max_upload_file_size
    if file && file.size > MAX_FILE_SIZE
      errors.add(:file, "File size must be less than #{MAX_FILE_SIZE}")
    end
  end
end
