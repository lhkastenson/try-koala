#!/usr/bin/env ruby -rubygems
gem 'koala'
gem 'json'
gem 'pony'
require 'net/smtp'
require 'koala'
require 'json'
require 'pony'

@emailBody = ""
@graph = Koala::Facebook::API.new('api-key')
group_id = 123456
@laff = @graph.get_object(group_id)
@feed = @graph.get_connections(group_id, "feed", {"fields"=>"message,id,created_time,comments.fields(from,message,created_time),from", "limit"=>5})
@feed.sort! { |x, y| y["created_time"] <=> x["created_time"] }
@feed.each do |post| 
	@emailBody += "---New Post---\n"
	#puts post['id']
	@emailBody += "At " + post['created_time'] + "\n"
	@emailBody += post['from']['name'] + " said\n" 
	@emailBody += post['message'] + "\n"
	if post['comments'] != nil
		@emailBody += "   ---Comments---\n"
		post['comments'].each do |inner|
			inner[1].each do |comment|
				if (comment.class == Hash) then
					@emailBody +=  "   At " + comment['created_time'] + "\n"
					@emailBody +=  "   " + comment['from']['name'] + " commmented\n"
					@emailBody +=  "   " + comment['message'] + "\n"
					@emailBody +=  "\n"
			end
			end
		end

		#puts 'At ' + post['comments']['created_time']
		#puts post['comments']['from']['name'] + ' commented'
		#puts post['comments']['message']
		#puts
	end
	@emailBody += "\n"
end
#send_email("xxx@xxx.com", "test")
Pony.mail(:to => 'xxx@xxx.com', :via => :smtp, :smtp => {
  :host     => 'smtp.gmail.com',
  :port     => '587',
  :user     => 'xxx',
  :password => '',
  :auth     => :plain,           # :plain, :login, :cram_md5, no auth by default
  :domain   => "gmail.com"     #
})
end