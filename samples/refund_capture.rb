require_relative './paypal_client' #PayPal SDK dependency
include PayPalCheckoutSdk::Payments
module Samples
    class RefundCapture

      # This is the sample function performing capture refund.
      # Valid capture id should be passed as an argument to this function
      def refund_capture (capture_id, debug=false)
        request = CapturesRefundRequest::new(capture_id)
        request.prefer("return=representation")
        # below request body can be populated to perform partial refund.
        request.request_body({
          amount: {
            value: '20.00',
            currency_code: 'USD'
          }
        });
        begin
          response = PayPalClient::client::execute(request)
        if debug
          puts "Status Code: #{response.status_code}"
          puts "Status: #{response.result.status}"
          puts "Refund ID: #{response.result.id}"
          puts "Intent: #{response.result.intent}"
          puts "Links:"
          for link in response.result.links
            # this could also be called as link.rel or link.href but as method is a reserved keyword for ruby avoid calling link.method
            puts "\t#{link["rel"]}: #{link["href"]}\tCall Type: #{link["method"]}"
          end
          puts PayPalClient::openstruct_to_hash(response.result).to_json
        end
        rescue PayPalHttp::HttpError => ioe
          # Exception occured while processing the refund.
          puts " Status Code: #{ioe.status_code}"
          puts " Debug Id: #{ioe.result.debug_id}"
          puts " Response: #{ioe.result}"
        end
        return response
      end
    end
end
# This is the driver function which invokes the refund capture function.
# Capture Id value should be replaced with the capture id.
if __FILE__ == $0
  Samples::RefundCapture::new::refund_capture('2WB02631FY659550C', true)
end
