require_relative "test_helper"

describe "ReservationManager" do
  let (:manager) { Hotel::ReservationManager.new }

  describe "Initialize" do
    it "Create an instance of ReservationManager" do
      # Assert
      expect(manager).must_be_kind_of Hotel::ReservationManager
    end

    it "Respond to all_rooms" do
      # Assert
      expect(manager).must_respond_to :all_rooms
      expect(manager.all_rooms).must_be_kind_of Array
      expect(manager.all_rooms.length).must_equal 20
    end

    it "Respond to reservations" do
      # Assert
      expect(manager).must_respond_to :all_reservations
      expect(manager.all_reservations).must_be_kind_of Array
      expect(manager.all_reservations).must_equal []
    end  
  end

  describe "available_rooms" do
    it "When no rooms have been booked return 20 available rooms" do
      rooms = manager.available_rooms("March 3, 2020", "March 5, 2020")
      # Assert
      expect(rooms.length).must_equal 20
    end

    it "When one room has been booked return 19 available rooms" do
      manager.make_reservation("March 3, 2020", "March 5, 2020")
      rooms = manager.available_rooms("March 3, 2020", "March 5, 2020")
      # Assert
      expect(rooms.length).must_equal 19
    end    

    it "Returns the available room" do
      manager.available_rooms("March 3, 2020", "March 5, 2020")
      rooms = manager.available_rooms("March 13, 2020", "March 15, 2020")
      # Assert
      expect(rooms.length).must_equal 20
    end
  end

  describe "make_reservation" do
    it "Creates a new reservation" do
      reservation = manager.make_reservation("March 3, 2020", "March 5, 2020")
      # Assert
      expect(reservation).must_be_kind_of Hotel::Reservation
      expect(manager.all_reservations.include?(reservation)).must_equal true
      expect(reservation.room.reservations.include?(reservation)).must_equal true
    end

    it "Raises an error if there are no rooms available" do
      20.times do
        manager.make_reservation("March 3, 2020", "March 5, 2020")
      end
      # Assert
      expect { manager.make_reservation("March 3, 2020", "March 5, 2020") }.must_raise StandardError
    end
  end

  describe "find_reservation" do
    it "Finds reservations for a specific date" do
      manager.make_reservation("March 1, 2020", "March 3, 2020") 
      manager.make_reservation("March 1, 2020", "March 8, 2020")
      manager.make_reservation("March 3, 2020", "March 6, 2020") 
      manager.make_reservation("March 3, 2020", "March 5, 2020")
      manager.make_reservation("March 15, 2020", "March 18, 2020")
      date = "March 3, 2020"
      specific_reservation = manager.find_reservation(date)
      # Assert
      expect(specific_reservation).must_be_kind_of Array
      expect(specific_reservation.length).must_equal 3

      specific_reservation.each do |reservation|
        _(reservation).must_be_kind_of Hotel::Reservation
      end
    end  
  end
end