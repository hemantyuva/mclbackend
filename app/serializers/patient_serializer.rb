class PatientSerializer < BaseSerializer
  attributes :id, :firstname, :phone, :lastname, :email, :dob, :gender
end