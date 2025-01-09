class Article < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  
  after_save :generate_summary, if: :content_changed?
  
  private
  
  def generate_summary
    return if content.blank?
    
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    
    prompt = "Please summarize the following text in 2-3 sentences: #{content}"
    
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: prompt }],
        max_tokens: 150,
        temperature: 0.7
      }
    )
    
    update_column(:summary, response.dig("choices", 0, "message", "content"))
  rescue => e
    Rails.logger.error("Failed to generate summary: #{e.message}")
  end  
end
