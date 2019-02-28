module Viewpoint::EWS::Types
  class Contact
    include Viewpoint::EWS
    include Viewpoint::EWS::Types
    include Viewpoint::EWS::Types::Item

    CONTACT_KEY_PATHS = {
      contact_source: [:contact_source, :text],
      display_name: [:display_name, :text],
      email_addresses: [:email_addresses, :elems],
    }
    CONTACT_KEY_TYPES = {
      email_addresses: :build_email_addresses,
    }
    CONTACT_KEY_ALIAS = {}

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

    def build_email_addresses(email_addresses)
      return [] if email_addresses.nil?
      email_addresses.collect{|e| e[:entry][:text]}
    end

    def key_paths
      @key_paths ||= CONTACT_KEY_PATHS
    end

    def key_types
      @key_types ||= CONTACT_KEY_TYPES
    end

    def key_alias
      @key_alias ||= CONTACT_KEY_ALIAS
    end

  end
end
