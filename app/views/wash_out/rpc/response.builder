xml.instruct!
xml.tag! "soap:Envelope", "xmlns:soap" => 'https://schemas.xmlsoap.org/soap/envelope/',
                          "xmlns:xsd" => 'https://www.w3.org/2001/XMLSchema',
                          "xmlns:xsi" => 'https://www.w3.org/2001/XMLSchema-instance',
                          "xmlns:tns" => @namespace do
  if !header.nil?
    xml.tag! "soap:Header" do
      xml.tag! "tns:#{@action_spec[:response_tag]}" do
        wsdl_data xml, header
      end
    end
  end
  xml.tag! "soap:Body" do
    xml.tag! "tns:#{@action_spec[:response_tag]}" do
      wsdl_data xml, result
    end
  end
end
