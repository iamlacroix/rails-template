unless Rails.env.production?
	ENV['MC_API_KEY'] = "8f14bf5f3b8278e8c3c727adefed6e9c-us4"
	ENV['MC_LIST_ID'] = "5cc42ffbc3"
	
	ENV['S3_ACCESS_KEY'] = "AKIAIETNVHEKMFVBTB6A"
	ENV['S3_SECRET_KEY'] = "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"
	ENV['S3_BUCKET'] = "RedBusProjectDev"
	
	ENV['APIGEE_TWITTER_API_ENDPOINT'] = "twitter-api-app3256811.apigee.com"
	
	ENV['USERNAME'] = "admin"
	ENV['PASSWORD'] = "mike177"
end