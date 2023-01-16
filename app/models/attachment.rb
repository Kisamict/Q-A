class Attachment < ApplicationRecord
  mount_uploader :file, FileUploader

  belongs_to :question
end
