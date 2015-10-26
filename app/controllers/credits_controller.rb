class CreditsController < ApplicationController
  before_action :set_credit, only: [:show, :edit, :update, :destroy]
  include ActionView::Helpers::NumberHelper

  def checkout
    @credit_holder = CreditHolder.find(params[:credit_holder_id])
  end

  def process_transaction
    @total = params[:total].to_f
    id = params[:credit_holder_id]
    @credits = Credit.credits_from_id(id)
    @oldest = @credits.sort_by { |c| c["created_at"]}.first
    @paymentamount = cashier(id, @total)
    CreditHolder.update_credits_total(params[:credit_holder_id])
    flash[:notice] = "Transaction Complete"
    redirect_to root_path

  end

  def add_credit(credit_holder, credit)
    new_total = credit.amount + credit_holder.credits_total
    CreditHolder.update(credit_holder.id, :credits_total => new_total)
  end

  # GET /credits
  # GET /credits.json
  def index
    @credits = Credit.all
  end

  # GET /credits/1
  # GET /credits/1.json
  def show
  end

  # GET /credits/new
  def new
    @credit = Credit.new
    @credit_holder_id = params[:credit_holder_id]
    @credit_holder = CreditHolder.find(@credit_holder_id)
  end

  # GET /credits/1/edit
  def edit
  end

  # POST /credits
  # POST /credits.json
  def create
    @credit = Credit.new(credit_params)

    respond_to do |format|
      if @credit.save
        notice = 'Credit was successfully created.'
        creditholder = CreditHolder.find(@credit.credit_holder_id)
        transaction = Transaction.new do |t|
          t.event = "create"
          t.amount = @credit.amount
          t.donate = @credit.donate
          t.num_books = @credit.num_books
          t.credit_id = @credit.id
          t.credit_holder_id = @credit.credit_holder_id
        end
        if transaction.save
          logger.info "New Transaction: #{transaction.attributes.inspect}"
        else
          logger.warn "Transaction did not save"
        end
        if  @credit[:send_email] == 1 && creditholder.email_address.present?
          CreditNotifier.created(creditholder,@credit).deliver
          notice = 'Credit was successfully created and Email notification was sent.'
        elsif @credit[:send_email] == 0
          notice = 'Credit was successfully created.'
        else
          notice = 'Credit was successfully created but Email notification was NOT sent, check to see if we have a valid email for that customer.'
        end
        add_credit(creditholder, @credit)
        format.html { redirect_to root_path, notice: notice }
        format.json { render :show, status: :created, location: @credit }
      else
        format.html { render :new }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /credits/1
  # PATCH/PUT /credits/1.json
  def update
    respond_to do |format|
      if @credit.update(credit_params)
        format.html { redirect_to @credit, notice: 'Credit was successfully updated.' }
        format.json { render :show, status: :ok, location: @credit }
      else
        format.html { render :edit }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credits/1
  # DELETE /credits/1.json
  def destroy
    @credit.destroy
    respond_to do |format|
      format.html { redirect_to credits_url, notice: 'Credit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit
      @credit = Credit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def credit_params
      params.require(:credit).permit(:amount, :expires_at, :status, :credit_holder_id, :send_email, :donate, :num_books)
    end

  	#TODO: this code is not DRY and out of place, refactor into cashier PORO?
    def cashier(holder_id,owed)
      subtotal = owed
      credits = Credit.credits_from_id(holder_id)
      payment = credits.sort_by { |c| c["created_at"]}.first

      if subtotal == 0
        logger.info "TOTAL IS ZERO"
        puts subtotal
      elsif payment.present? != true
        logger.info "NO PAYMENT PRESENT #{owed} IS STILL OWED"
        return owed
      elsif payment.present? and subtotal >= payment["amount"]
        logger.info "PAYMENT OF #{payment['amount']} IS PRESENT AND LESS THAN OR EQUAL TO THE TOTAL OF #{subtotal}"
        remainder = subtotal - payment["amount"]
        Credit.credit_used(payment["id"])
        transaction = Transaction.new do |t|
              t.event = "use"
              t.amount_used = payment["amount"]
              t.amount_remaining = 0
              t.credit_id = payment["id"]
              t.credit_holder_id = holder_id
            end
            if transaction.save
              logger.info "New Transaction: #{transaction.attributes.inspect}"
            else
              logger.warn "Transaction did not save"
            end
        payment = nil
      elsif payment.present? and subtotal < payment["amount"]
        logger.info "THE PAYMENT OF #{payment['amount']} IS PRESENT AND GREATER THAN THE TOTAL OF #{subtotal}"
        change = payment["amount"] - subtotal
        Credit.credit_balance(payment["id"], change)
        transaction = Transaction.new do |t|
              t.event = "use"
              t.amount_used = subtotal
              t.amount_remaining = change
              t.credit_id = payment["id"]
              t.credit_holder_id = holder_id
            end
            if transaction.save
              logger.info "New Transaction: #{transaction.attributes.inspect}"
            else
                logger.warn "Transaction did not save"
            end
      end

      if remainder
        puts "#{remainder} IS STILL OWED USING NEXT CREDIT"
        cashier(holder_id,remainder)
      end
    end

end
