class Freshdesk::Ticket < Freshdesk::Base
  STATUS_ENUM = {
      "Open" => 2,
      "Pending" => 3,
      "Resolved" => 4,
      "Closed" => 5
  }

  PRIORITY_ENUM = {
      "Low" => 1,
      "Medium" => 2,
      "High" => 3,
      "Urgent" => 4
  }

  SOURCE_ENUM = {
      "Email" => 1,
      "Portal" => 2,
      "Phone" => 3,
      "Chat" => 7,
      "Mobihelp" => 8,
      "Feedback Widget" => 9,
      "Outbound Email" => 10
  }

  validates_inclusion_of :status, in: STATUS_ENUM.values
  validates_inclusion_of :priority, in: PRIORITY_ENUM.values
  validates_inclusion_of :source, in: SOURCE_ENUM.values

  def self.from_feedback(feedback)
    status = feedback.done? ? 4 : 2

    data = {
        email: feedback.email,
        name: feedback.name,
        status: status,
        source: 9,
        priority: 1,
        subject: (feedback.comment||"").first(80),
        description: feedback.comment,
        custom_fields: {
            cf_source_url: feedback.source_url || "",
            cf_browser: feedback.visit&.browser || "",
            cf_operating_system: feedback.visit&.os || "",
            cf_environment: Rails.env
        }
    }

    new(data)
  end
end
