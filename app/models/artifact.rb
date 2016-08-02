class Artifact < ActiveRecord::Base
  MAX_FILE_SIZE = 10.megabytes

  attr_accessor :file
  belongs_to :project
  validates_uniqueness_of :name
  validates_presence_of :name, :file

  validate :uploaded_file_size

  private

  def uploaded_file_size
    if file && file.size > MAX_FILE_SIZE
      errors.add(:file, "File size must be less than #{MAX_FILE_SIZE}")
    end
  end
end
