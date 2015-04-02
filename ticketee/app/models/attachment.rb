class Attachment < ActiveRecord::Base
  belongs_to :ticket

  mount_uploader :file, AttachmentUploader
end
