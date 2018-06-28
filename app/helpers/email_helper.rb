module EmailHelper
    def email_image_tag(image, **options)
		attachments.inline[image] = {
                                :data => File.read(Rails.root.join("data","#{image}")),
                                :mime_type => "image/jpg",
                                :encoding => "base64"
                              }
        image_tag attachments[image].url, **options
    end
end