xml.instruct!
xml.tag! "soap:Envelope", "xmlns:soap" => 'https://schemas.xmlsoap.org/soap/envelope/',
                          "xmlns:xsi" => 'https://www.w3.org/2001/XMLSchema-instance' do
  xml.tag! "soap:Body" do
    xml.tag! "soap:Fault", :encodingStyle => 'https://schemas.xmlsoap.org/soap/encoding/' do
      xml.faultcode error_code, 'xsi:type' => 'xsd:QName'
      xml.faultstring error_message, 'xsi:type' => 'xsd:string'
    end
  end
end
