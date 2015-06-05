class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def dashboard
    
  end

  def report
    @transactions = init_report(params[:type])
    report = params[:type]+"_report"
    respond_to do |format|
      format.html {}
      format.xlsx {render report}
    end
  end
  
  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
  end
  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        Rails.logger.info "New Transaction: #{@transaction.attributes.inspect}"
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:type, :credit_holder_id, :amount, :donate, :num_books, :amount_used, :amount_remaining)
    end

    def init_report(type)
      case type
        when "daily"
          return Transaction.where("created_at >= ?", Time.zone.now.beginning_of_day)
        when "weekly"
          return Transaction.date_range("any", Date.today.beginning_of_week.beginning_of_day, DateTime.now)
        when "monthly"
          return Transaction.date_range("any", Date.today.beginning_of_month.beginning_of_day, DateTime.now)
        when "quarterly"
          generate_quarterly_report
        when "annual"
          generate_annual_report
      end
    end
end
