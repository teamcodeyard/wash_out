xml.instruct!
xml.definitions 'xmlns' => 'https://schemas.xmlsoap.org/wsdl/',
                'xmlns:tns' => @namespace,
                'xmlns:soap' => 'https://schemas.xmlsoap.org/wsdl/soap/',
                'xmlns:xsd' => 'https://www.w3.org/2001/XMLSchema',
                'xmlns:soap-enc' => 'https://schemas.xmlsoap.org/soap/encoding/',
                'xmlns:wsdl' => 'https://schemas.xmlsoap.org/wsdl/',
                'name' => @name,
                'targetNamespace' => @namespace do

  xml.types do
    xml.tag! "schema", :targetNamespace => @namespace, :xmlns => 'https://www.w3.org/2001/XMLSchema' do
      defined = []
      @map.each do |operation, formats|
        (formats[:in] + formats[:out]).each do |p|
          wsdl_type xml, p, defined
        end
      end
    end
  end

  @map.each do |operation, formats|
    xml.message :name => "#{operation}" do
      formats[:in].each do |p|
        xml.part wsdl_occurence(p, false, :name => p.name, :type => p.namespaced_type)
      end
    end
    xml.message :name => formats[:response_tag] do
      formats[:out].each do |p|
        xml.part wsdl_occurence(p, false, :name => p.name, :type => p.namespaced_type)
      end
    end
  end

  xml.portType :name => "#{@name}_port" do
    @map.each do |operation, formats|
      xml.operation :name => operation do
        xml.input :message => "tns:#{operation}"
        xml.output :message => "tns:#{formats[:response_tag]}"
      end
    end
  end

  xml.binding :name => "#{@name}_binding", :type => "tns:#{@name}_port" do
    xml.tag! "soap:binding", :style => 'document', :transport => 'https://schemas.xmlsoap.org/soap/http'
    @map.keys.each do |operation|
      xml.operation :name => operation do
        xml.tag! "soap:operation", :soapAction => operation
        xml.input do
          xml.tag! "soap:body",
            :use => "literal",
            :namespace => @namespace
        end
        xml.output do
          xml.tag! "soap:body",
            :use => "literal",
            :namespace => @namespace
        end
      end
    end
  end

  xml.service :name => @service_name do
    xml.port :name => "#{@name}_port", :binding => "tns:#{@name}_binding" do
      xml.tag! "soap:address", :location => WashOut::Router.url(request, @name)
    end
  end
end
