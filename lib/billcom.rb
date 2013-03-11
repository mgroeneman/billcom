require "billcom/version"
require 'nokogiri'
require 'httparty'

  URL = "https://api.bill.com/crudApi"
  CONTENT_TYPE = "application/x-www-form-urlencoded"

module Billcom

  def self.options(opt)
    @user = opt[:user]
    @pw = opt[:password]
    @org = opt[:org_id]
    @api = opt[:api_key]
  end

  def self.login
    login_req = Nokogiri::XML::Builder.new do |xml|
      xml.request(:version => "1.0", :applicationkey => @api) {
        xml.login {
        xml.username {
        xml.cdata @user
      }
      xml.password {
        xml.cdata @pw
      }
      xml.orgID {
        xml.cdata @org
      }
      }
      }
    end
    login_response = post_request(login_req)
    @@session_id = Nokogiri::XML(login_response.body).child.search("//sessionId").first.text
  end

  def self.create_vendor(name, email, external_id)
    vendor = Nokogiri::XML::Builder.new do |xml|
      xml.request(:version => "1.0", :applicationkey => @api) {
        xml.operation(:sessionId => @@session_id) {
        xml.create_vendor {
        xml.vendor {
        xml.name {
        xml.cdata name
      }
      xml.track1099 {
        xml.cdata "1"
      }
      xml.externalId {
        xml.cdata external_id
      }
      xml.email {
        xml.cdata email
      }
      }
      }
      }
      }
    end
    create_vendor_response = post_request(vendor)
    vendor_id = get_id(create_vendor_response)
    vendor_id
  end

  def self.send_vendor_invite(vendor_id, email)
    invite = Nokogiri::XML::Builder.new do |xml|
      xml.request(:version => "1.0", :applicationkey => @api) {
        xml.operation(:sessionId => @@session_id) {
        xml.send_vendor_invite {
        xml.vendorId {
        xml.cdata vendor_id
      }
      xml.email {
        xml.cdata email
      }
      }
      }
      }
    end
    invite_response = post_request(invite)
    vendor_invite_id = get_id(invite_response)
    vendor_invite_id
  end

  def self.create_bill(invoice_number, vendor_id, amount, chart_of_account_id, external_id, invoice_date, due_date)
    bill = Nokogiri::XML::Builder.new do |xml|
      xml.request(:version => "1.0", :applicationkey => @api) {
        xml.operation(:sessionId => @@session_id) {
        xml.create_bill {
        xml.bill {
        xml.invoiceNumber {
          xml.cdata invoice_number
        }
        xml.vendorId {
          xml.cdata vendor_id
        }
        xml.externalId {
          xml.cdata external_id
        }
        xml.amount {
          xml.cdata amount
        }
        xml.invoiceDate {
          xml.cdata invoice_date
        }
        xml.dueDate {
          xml.cdata due_date
        }
        xml.billLineItems {
          xml.billLineItem {
            xml.amount {
              xml.cdata amount
            }
            xml.chartOfAccountId {
              xml.cdata chart_of_account_id
            }
          }
        }
      }
      }
      }
      }
    end
    create_bill_response = post_request(bill)
    bill_id = get_id(create_bill_response)
    bill_id
  end

  def self.pay_bill(bill_id, amount, process_date)
    payment = Nokogiri::XML::Builder.new do |xml|
      xml.request(:version => "1.0", :applicationkey => @api) {
        xml.operation(:sessionId => @@session_id) {
        xml.pay_bill {
        xml.billId {
          xml.cdata bill_id
        }
        xml.amount {
          xml.cdata amount
        }
        xml.processDate {
          xml.cdata process_date
        }
      }
      }
      }
    end
    pay_bill_response = post_request(payment)
    payment_id = get_id(pay_bill_response)
    payment_id
  end

  # Not currently using the invoice api
  # def self.create_invoice(invoice_number, vendor_id, amount, invoice_date, due_date)
  #   invoice = Nokogiri::XML::Builder.new do |xml|
  #     xml.request(:version => "1.0", :applicationkey => @api) {
  #       xml.operation(:sessionId => @@session_id) {
  #       xml.create_invoice {
  #       xml.invoice {
  #       xml.isActive {
  #         xml.cdata "1"
  #       }
  #       xml.customerId {
  #         xml.cdata "0cu01FDLFFRGOXS24r2w"
  #       }
  #       xml.invoiceNumber {
  #         xml.cdata invoice_number
  #       }
  #       xml.invoiceDate {
  #         xml.cdata invoice_date
  #       }
  #       xml.dueDate {
  #         xml.cdata due_date
  #       }
  #       xml.invoiceLineItems {
  #         xml.invoiceLineItem {
  #           xml.price {
  #             xml.cdata amount
  #           }
  #           xml.amount {
  #             xml.cdata amount
  #           }
  #         }
  #       }
  #     }
  #     }
  #     }
  #     }
  #   end
  #   create_invoice_response = post_request(invoice)
  #   invoice_id = get_id(create_invoice_response)
  #   invoice_id
  # end

  private

  def self.get_id(response)
    Nokogiri::XML(response.body).child.search("//id").first.text
  end

  def self.post_request(nokogiri_xml)
    response = HTTParty.post(URL, create_options(nokogiri_xml))
    check_status(response)
    response
  end

  def self.create_options(nokogiri_xml)
    { :body => "request=#{nokogiri_xml.to_xml}", :content_type => CONTENT_TYPE }
  end

  def self.check_status(response)
    status = Nokogiri::XML(response.body).child.search("//status").first.text
    if status == "OK" 
      return
    else 
      raise status
    end
  end

end

