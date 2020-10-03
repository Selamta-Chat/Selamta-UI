module PackagesHelper

    # Display the Package name according to the Parameter passed
  
    def package_name(package)
      case package
      when "1"
        pack = "Enterprise"
        pack.html_safe
      when "2"
        pack = "Business"
        pack.html_safe
      when "3"
        pack = "Professional"
        pack.html_safe
      end
    end
  
    # Set the status of the Pakage eg:- New or paid
    def package_status(current_user)
      # get the Current User and Read from the Package Table if the user has existing
      # new package deny and show another package and delete
  
      logger.info "See USER PACK=> #{current_user.uid}"
    end
  
    # Set the Order Code that is returned from yene pay integration
    # Initially set a random string  as a place holder
  
    def package_code(package)
      return code = current_user.uid
      code.html_safe if package != "0"
      logger.info "Order Code => #{current_user.uid}"
    end
  
    # Set the Current date as the Date by default if there is no date returned from the db
    def package_created_date
      return Date.today.to_s
    end
  
    # check package exists
    def package_date_exists(date)
      # Return false to show -- if there is no date
      if date.to_s.empty?
        return false
      else
        return true
      end
    end
  
    # check package transaction code exists
    def package_transaction_exists(transaction)
      # Return false to show -- if there is no transaction
      if transaction.to_s.empty?
        return false
      else
        return true
      end
    end
  
    # check package currency
    def package_currency_exists(currency)
      # Return false to show -- if there is no currency
      if currency.to_s.empty?
        return false
      else
        return true
      end
    end
  
    # check package cancel
    def package_cancel_exists(cancel)
      logger.info "CANCEL Code => #{cancel}"
      # Return false to show -- if there is no currency
      if cancel.to_s.empty?
        return false
      else
        return true
      end
    end
  
    # Returns the Selected Cycle from the Drop Down
  
    def package_selected_cycle(cycle)
      case cycle
      when "1"
        pack = "1 Month"
        pack.html_safe
      when "3"
        pack = "3 Months"
        pack.html_safe
      when "6"
        pack = "6 Months"
        pack.html_safe
      when "12"
        pack = "1 Year"
        pack.html_safe
      else
        pack = "Select the Bill Cycle"
        pack.html_safe
      end
    end
  
    # Set Unit Price
    def package_unit_price(package)
      case package
      when "1"
        pack = "600"
        pack.html_safe
      when "2"
        pack = "500"
        pack.html_safe
      when "3"
        pack = "350"
        pack.html_safe
      end
    end
  
    #Set Subtotal
    def package_subtotal(package, cycle)
      if cycle.to_i != 0
        case package
        when "1"
          pack = 600 * cycle.to_i
          return pack
        when "2"
          pack = 500 * cycle.to_i
          return pack
        when "3"
          pack = 350 * cycle.to_i
          return pack
        end
      end
      # When there is no cycle parameter in the url execute the Following
      if cycle.to_i == 0
        case package
        when "1"
          pack = 600 * 1
          return pack
        when "2"
          pack = 500 * 1
          return pack
        when "3"
          pack = 350 * 1
          return pack
        end
      end
    end
  
    #Set Discount
    def package_discount(package)
      case package
      when "1"
        pack = "0"
        pack.html_safe
      when "2"
        pack = "0"
        pack.html_safe
      when "3"
        pack = "0"
        pack.html_safe
      end
    end
  
    # Set VAT
    def package_vat(package)
      case package
      when "1"
        pack = "15%"
        pack.html_safe
      when "2"
        pack = "15%"
        pack.html_safe
      when "3"
        pack = "15%"
        pack.html_safe
      end
    end
   
    # set the Total for each package
    # first calculate the total Vat Amount from the Entire Bill cycle
    # second calculate the total amount plus calculated VAT amount
    def package_total(package, cycle)
      if cycle.to_i != 0
        case package
        when "1" 
          pack = (600 * cycle.to_i) * 0.15
          vat = (600 * cycle.to_i) + pack
          vat = vat.to_i
          total = vat.to_s + " ETB"
          total.html_safe  
          return total
        when "2"
          pack = (500 * cycle.to_i) * 0.15
          vat = (500 * cycle.to_i) + pack
          vat = vat.to_i
          total = vat.to_s + " ETB"
          total.html_safe
          return total
        when "3"
          pack = (350 * cycle.to_i) * 0.15
          vat = (350 * cycle.to_i) + pack
          vat = vat.to_i
          total = vat.to_s + " ETB"
          total.html_safe
          return total
        end
      end
  
      if cycle.to_i == 0
        case package
        when "1"
          pack = (600 * 1) * 0.15
          vat = (600 * 1) + pack
          vat = vat.to_i
          total = vat.to_s + " ETB"
          total.html_safe
          return total
        when "2"
          pack = (500 * 1) * 0.15
          vat = (500 * 1) + pack
          vat = vat.to_i
          total = vat.to_s + " ETB"
          total.html_safe
          return total
        when "3"
          pack = (350 * 1) * 0.15
          vat = (350 * 1) + pack
          vat = vat.to_i
          total = vat.to_s + " ETB"
          total.html_safe
          return total
        end
      end
    end
  end
  