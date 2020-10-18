class PackagesController < ApplicationController
  include Pagy::Backend

  #before_action :package_params, only: [:new]

  def show

    # if the Merchant order code is not empty send cancel request
    if params.has_key?(:cancel)
      cancelPackage = HTTParty.post("http://localhost:3030/api/packages/",
                                    {
        :headers => {
          "Content-Type" => "application/json",
          "user_id" => "#{current_user.uid}",
          "merchant_order_id" => "#{params[:cancel]}",
        },
      })

      # after cancel redirect back to create page
      if cancelPackage
        redirect_to create_package_path
      end
    end
  end

  def new
    return redirect_to signin_path(:package => params[:package]),
                       flash: { info: I18n.t("login_required") } unless current_user

    if current_user
      return redirect_to create_package_path packages: params[:package]
    end
  end

  def create
    # TODO:: Implement allPayments for the Table Show Method
    allPayments = HTTParty.get("http://localhost:3030/api/packages/",
                               :headers => {
                                 "Content-Type" => "application/json",
                                 "user_id" => "#{current_user.uid}",
                               })
    # Pass the pages from the parameter Set the items per table to be 5
    @pagy, @packages = pagy_array(allPayments.to_a, page: params["page"], items: 5)
  end

  # This is actually the payment package change def name to payment_New
  def pay
    newPaymentExists = HTTParty.get("http://localhost:3030/api/packages/#{current_user.uid}",
                                    :headers => {
                                      "Content-Type" => "application/json",
                                    })
    newPaymentExists = JSON.parse(newPaymentExists.body)

    if newPaymentExists == false
      redirect_link
    else
      flash[:alert] = I18n.t("package.flash_new")
    end
  end

  def set_bill_cycle
    redirect_to create_package_path packages: params[:package], cycle: params[:value]

    # package_params[:cycle] = params[:value]
    #helpers.set_bill_cycle(cycle)

    #redirect_to  create_package_path
  end

  # Determines the Payment Redirect Link
  def redirect_link
    if params.has_key?(:package)
    else
      # A package MUST be selected to route to Selamta Pay
      flash[:alert] = I18n.t("package.select_package")
      return redirect_to create_package_path
    end

    if params.has_key?(:cycle)
      redirect_to "http://localhost:3030/index?package=#{params[:package]}&cycle=#{params[:cycle]}&uid=#{params[:uid]}"
    else
      redirect_to "http://localhost:3030/index?package=#{params[:package]}&cycle=1&uid=#{params[:uid]}"
    end
  end

  private

  def package_params
    # @package = Package.find_by(uid: current_user.uid)
    #params.require(:package).permit(:item_id, :cycle)
  end
end
