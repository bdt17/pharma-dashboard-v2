class ElectronicSignaturesController < ApplicationController
  def new
    @shipment = Shipment.last || Shipment.create(truck_id: 1)
  end
  
  def create
    # Fake DocuSign
    @shipment.update(signature_status: 'signed')
    redirect_to dashboard_path, notice: "✅ DocuSign DEA Form 222 Signed"
  end
end
