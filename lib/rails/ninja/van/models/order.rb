module Rails
  module Ninja
    module Van
      module Models
        class Order
          attr_reader :errors, :message, :status, :tracking_id, :id
          mattr_accessor :columns

          def initialize(type, attrs={})
            self.columns = self.class.load_columns :order, type
            singleton_attributes
            set_attributes_with_columns attrs
          end

          def save
            return false if columns_validation.present?
            post = Rails::Ninja::Van::Api.post "3.0/orders", [save_params]
            parse_data_for_save post
          end

          def to_h
            self.columns.inject({}) do |hash, col|
              hash[col] = self.send(col)
              hash
            end
          end

          class << self
            alias_method :make, :new

            def new(attrs={})
              make :new, attrs
            end

            def find(order_id)
              return if order_id.blank?
              get = Rails::Ninja::Van::Api.get "2.0/orders/#{order_id}"
              parse_data_for_find get
            end

            def cancel(order_id)
              return if order_id.blank?
              delete = Rails::Ninja::Van::Api.delete "2.0/orders/#{order_id}"
              parse_data_for_cancel delete
            end

            def load_columns(model, type)
              file = File.join(File.dirname(__FILE__),"columns.yml")
              YAML::load_file(file)[model.to_s][type.to_s].map(&:to_sym)
            end

            private
            def parse_data_for_find(get)
              response = get.body.symbolize_keys
              case get.code
              when 200
                make :find, response
              when 500
                raise response[:errorMessage]
              end
            end

            def parse_data_for_cancel(delete)
              case delete.code
              when 404
                raise "Not found: #{delete.body}"
              when 500
                raise "NINJA-VAN Server error: #{delete.body}"
              when 200
                body = delete.body.symbolize_keys
                return make :cancel, { tracking_id: body[:trackingId], status: body[:status], updated_at: body[:updatedAt] }
              end
            end
          end

          private
          def save_params
            self.to_h.inject({}) do |hash, (k, v)|
              hash[k] = v if v.present?
              hash
            end
          end

          def singleton_attributes
            self.columns.each{ |col| singleton_class.class_eval { mattr_accessor col } }
          end

          def set_attributes_with_columns attrs
            return if attrs.blank?
            attrs.symbolize_keys!
            self.columns.each{ |col| send("#{col}=", attrs[col]) }
          end

          def columns_validation
            @errors = self.class.load_columns(:order, :required).inject({}) do |hash, col|
              hash[col] = "can't be blank" if self.send(col).blank?
              hash
            end
          end

          def parse_data_for_save(post)
            data = post.body.first.symbolize_keys
            @status = data[:status]
            @message = data[:message]
            if @status == "SUCCESS"
              @id = data[:id]
              @tracking_id = data[:tracking_id]
              return true
            end
            @errors = [@message]
            return false
          end
        end
      end
    end
  end
end
