require 'test_helper'

class EncodingCompatibilityTest < ActionDispatch::IntegrationTest
  test 'malformed UTF-16LE multipart params return 400 instead of 500' do
    value = 'value'.encode('UTF-16LE').b
    body = (+'').b
    body << "------X\r\n"
    body << "Content-Disposition: form-data; name=\"field\"\r\n"
    body << "Content-Type: text/plain; charset=UTF-16LE\r\n"
    body << "\r\n"
    body << value
    body << "\r\n------X--\r\n"

    post '/users/sign_in', headers: {
      'CONTENT_TYPE' => 'multipart/form-data; boundary=----X',
      'CONTENT_LENGTH' => body.bytesize.to_s
    }, env: { 'rack.input' => StringIO.new(body) }

    assert_response :bad_request
  end
end
