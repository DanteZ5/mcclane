class Api::V1::TemplatesController < Api::V1::BaseController
  # FIXME: faille secu

  def voice
    template = Template.find(params[:id])
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(template.content, voice: 'alice')
    end
    render xml: response.to_s

  end
end
