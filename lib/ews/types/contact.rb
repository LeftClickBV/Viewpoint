module Viewpoint::EWS::Types
  class Contact
    include Viewpoint::EWS
    include Viewpoint::EWS::Types
    include Viewpoint::EWS::Types::Item

    CONTACT_KEY_PATHS = {
      given_name:         [:given_name, :text],
      surname:            [:surname, :text],
      display_name:       [:display_name, :text],
      company_name:       [:company_name, :text],
      email_addresses:    [:email_addresses, :elems],
      physical_addresses: [:physical_addresses, :elems],
      phone_numbers:      [:phone_numbers, :elems],
      department:         [:department, :text],
      job_title:          [:job_title, :text],
      office_location:    [:office_location, :text],
    }

    CONTACT_KEY_TYPES = {
      email_addresses:    :build_email_addresses,
      physical_addresses: :build_physical_addresses,
      phone_numbers:      :build_phone_numbers
    }

    CONTACT_KEY_ALIAS = {
      first_name:      :given_name,
      last_name:       :surname,
      emails:          :email_addresses,
      addresses:       :physical_addresses,
      title:           :job_title,
      company:         :company_name,
      office:          :office_location,
    }

    def initialize(ews, contact)
      @ews = ews
      @ews_item = contact
      simplify!
    end

    private

    def simplify!
      @ews_item = @ews_item.inject({}) do |o,i|
        key = i.keys.first
        if o.has_key?(key)
          if o[key].is_a?(Array)
            o[key] << i[key]
          else
            o[key] = [o.delete(key), i[key]]
          end
        else
          o[key] = i[key]
        end
        o
      end
    end

    def build_phone_number(phone_number)
      Types::PhoneNumber.new(ews, phone_number)
    end

    def build_phone_numbers(phone_numbers)
      return [] if phone_numbers.nil?
      phone_numbers.collect { |pn| build_phone_number(pn[:entry]) }
    end

    def build_email_address(email)
      Types::EmailAddress.new(ews, email)
    end

    def build_email_addresses(users)
      return [] if users.nil?
      users.collect { |u| build_email_address(u[:entry]) }
    end

    def build_physical_address(address_ews)
      Types::PhysicalAddress.new(ews, address_ews)
    end

    def build_physical_addresses(addresses)
      return [] if addresses.nil?
      addresses.collect { |a| build_physical_address(a[:entry]) }
    end

    def key_paths
      super.merge(CONTACT_KEY_PATHS)
    end

    def key_types
      super.merge(CONTACT_KEY_TYPES)
    end

    def key_alias
      super.merge(CONTACT_KEY_ALIAS)
    end


  end
end
