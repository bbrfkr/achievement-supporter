require 'discordrb'

BOT_TOKEN = ENV['DISCORD_BOT_TOKEN']
BOT_CLIENT_ID = ENV['DISCORD_CLIENT_ID']

DISCORD_BOT = Discordrb::Bot.new token: BOT_TOKEN, client_id: BOT_CLIENT_ID

DISCORD_BOT.message do |event|
  # only react when mentioned
  if event.message.mentions.include?(DISCORD_BOT.profile)
    content = if event.channel.thread?
                thread_channel = event.channel
                original_message_id = thread_channel.id
                parent_channel_id = thread_channel.parent_id
                parent_channel = event.bot.channel(parent_channel_id)
                original_message = parent_channel.message(original_message_id)
                event.channel.history(100).map(&:content).append(original_message.content).reverse.join("\n---\n")
              else
                event.message.content
              end
    extracted_content = content.sub(/<@!?#{DISCORD_BOT.profile.id}>/, '').strip
    # uri = URI('https://n8n.external.dynamis.bbrfkr.net/webhook-test/ae85f6e0-9359-46a9-9dbb-1fe4075158b2') 
    uri = URI('https://n8n.external.dynamis.bbrfkr.net/webhook/ae85f6e0-9359-46a9-9dbb-1fe4075158b2')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request.body = { msg: extracted_content }.to_json
    response = http.request(request)
    msg = JSON.parse(response.body)["msg"]

    respond(msg, event: event)
  end
end

def split_into_chunks(text, max_length = 2000)
  chunks = []
  while text.length > max_length
    slice = text[0, max_length]
    split_pos = slice.rindex(/\n|[。．.!?]/) || max_length
    chunks << text[0, split_pos].strip
    text = text[split_pos..-1].strip
  end
  chunks << text unless text.empty?
  chunks
end

def respond(msg, event:, chuck_count: 2000)

  if event.channel.thread?
    split_into_chunks(msg, chuck_count).each do |chunk|
      event.respond chunk
      sleep 0.5
    end
  else
    thread = event.channel.start_thread("test", 10080, message: event.message)
    split_into_chunks(msg, chuck_count).each do |chunk|
      thread.send_message chunk
      sleep 0.5
    end
  end
end

# Start the bot in a separate thread so it doesn't block Rails
Thread.new { DISCORD_BOT.run }
