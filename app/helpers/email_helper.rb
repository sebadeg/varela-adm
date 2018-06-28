module EmailHelper
    def email_image_tag(image, **options)
		attachments.inline[image] = {
                                :data => File.read("#{Rails.root.to_s}/app/assets/images/#{image}"),
                                :mime_type => "image/jpg",
                                :encoding => "base64"
                              }
        image_tag attachments[image].url, id: 'offer_image', **options
    end
end