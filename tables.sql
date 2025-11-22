use silvercare;

CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` ENUM('USER','ADMIN') NOT NULL DEFAULT 'USER',
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(250) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` varchar(150) DEFAULT NULL,
  `emergency_contact` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  `blk_no` varchar(50) DEFAULT NULL,
  `unit_no` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
);

CREATE TABLE `service_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `description` varchar(2500) NOT NULL, 
  PRIMARY KEY (`id`)
);

CREATE TABLE `service` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `description` text NOT NULL,
  `hourly_rate` int NOT NULL,
  `image_url` text NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `service_category_service_fk` (`category_id`),
  CONSTRAINT `service_category_service_fk` FOREIGN KEY (`category_id`) REFERENCES `service_category` (`id`)
);

CREATE TABLE `caregiver_qualification` (
  `qualification_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`qualification_id`),
  UNIQUE KEY `qualification_id` (`qualification_id`),
  UNIQUE KEY `name` (`name`)
);

CREATE TABLE `service_caregiver_qualification` (
  `caregiver_qualification_id` int NOT NULL,
  `service_id` int NOT NULL,
  PRIMARY KEY (`caregiver_qualification_id`, `service_id`),
  FOREIGN KEY (`caregiver_qualification_id`) REFERENCES `caregiver_qualification`(`qualification_id`) ON DELETE CASCADE,
  FOREIGN KEY (`service_id`) REFERENCES `service`(`id`) ON DELETE CASCADE
);

CREATE TABLE booking (
  id int NOT NULL AUTO_INCREMENT,
  user_id int NOT NULL,
  service_id int NOT NULL,
  booking_date date NOT NULL,
  booking_time time NOT NULL,
  duration_hours int NOT NULL,
  total_price decimal(10,2) NOT NULL,
  status enum('PENDING','CONFIRMED','CANCELLED','COMPLETED') NOT NULL DEFAULT 'PENDING',
  notes text,
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY booking_user_fk (user_id),
  KEY booking_service_fk (service_id),
  CONSTRAINT booking_service_fk FOREIGN KEY (service_id) REFERENCES service (id) ON DELETE CASCADE,
  CONSTRAINT booking_user_fk FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
);

DELIMITER //
CREATE PROCEDURE register_user (
  IN p_username VARCHAR(100),
  IN p_password VARCHAR(100),
  IN p_email VARCHAR(250),
  IN p_first_name VARCHAR(100),
  IN p_last_name VARCHAR(100),
  IN p_phone VARCHAR(50),
  IN p_address VARCHAR(150),
  IN p_emergency_contact VARCHAR(50),
  IN p_blk_no VARCHAR(50),
  IN p_unit_no VARCHAR(50),
  OUT p_id INT,
  OUT p_role ENUM('USER', 'ADMIN'),
  OUT p_success BOOLEAN,
  OUT p_message VARCHAR(100)
)
BEGIN
  IF EXISTS (SELECT 1 FROM user WHERE username = p_username) THEN
	SET p_id = NULL;
	SET p_role = NULL;
    SET p_success = false;
    SET p_message = 'USERNAME ALREADY EXISTS';
  ELSE
    INSERT INTO user (username, password, email, first_name, last_name, phone, address, emergency_contact, blk_no, unit_no) 
	  VALUES (p_username, p_password, p_email, p_first_name, p_last_name, p_phone, p_address, p_emergency_contact, p_blk_no, p_unit_no);

	SET p_id = LAST_INSERT_ID();
	SELECT role INTO p_role FROM user WHERE id = p_id;
    SET p_success = true;
    SET p_message = 'REGISTER_SUCCESS';
  END IF;
END;
// DELIMITER ;

INSERT INTO service_category (name, description) VALUES 
("In-Home Care", "Care for those at home"), 
("Assisted Living Support", "Assistant for daily chores/housework"), 
("Specialized Care", "Care service for elderlies with dementia"), 
("Additional Services", "Other types of services we provide to care for the elderly");

INSERT INTO service (name, description, hourly_rate, image_url, category_id) VALUES
('Basic Care', 'Daily basic care for seniors', 35, 'https://magnoliaterracegalion.com/wp-content/uploads/2025/03/Daily-Care-for-Elderly-Individuals-Best-Practices-to-Follow.png', 3),
('Advanced Care', 'Specialized care for seniors with trained staff', 50, 'https://www.nccdp.org/wp-content/uploads/2024/03/physical-therapist-nurse-helping-patient-to-exercise-with-dumbbells-at-home.jpg', 2),
('Night Care', 'Overnight monitoring and support', 45, 'https://bigheartshomecare.ca/wp-content/uploads/2021/06/overnight-home-care-services-1.jpg', 1),
('Physical Therapy', 'Rehabilitation and mobility support', 60, 'https://www.physio.co.uk/images/reduced-mobility/reduced-mobility1.jpg', 3),
('Companion Care', 'Social and emotional support', 30, 'https://rivergardenhomecare.co.uk/wp-content/uploads/2025/02/DeWatermark.ai_1740382287266.png', 1),
('Memory Care', 'Special care for memory loss and dementia', 55, 'https://domf5oio6qrcr.cloudfront.net/medialibrary/15758/gettyimages-1390975000.jpg', 2),
('Medication Management', 'Assistance with medication schedules', 40, 'https://www.seniorhelpers.com/site/assets/files/411094/caretaker_helping_a_senior_woman_in_bed_with_medication.480x0.webp', 2),
('Meal Preparation', 'Nutritious meals prepared daily', 25, 'https://companionsforseniors.com/wp-content/uploads/2019/03/2019-3-25-The-Importance-of-Meal-Prep-for-Seniors.jpg', 1),
('Transportation Services', 'Safe transport to appointments and activities', 20, 'https://example.com/images/transport.jpg', 3),
('Respite Care', 'Temporary relief for primary caregivers', 50, 'https://spedsta.com/wp-content/uploads/2025/04/the-benefits-of-specialized-transportation-for-seniors.jpg', 1);

INSERT INTO caregiver_qualification (name, description) VALUES
('CPR Certified', 'Certified in Cardiopulmonary Resuscitation (CPR) for emergency situations.'),
('First Aid', 'Trained in basic first aid techniques for common injuries and emergencies.'),
('Medication Administration', 'Authorized and trained to administer prescribed medications safely.'),
('Dementia Care', 'Specialized in caring for patients with Alzheimer\'s or other forms of dementia.'),
('Mobility Assistance', 'Skilled in assisting seniors with walking, transfers, and mobility devices.'),
('Nutrition & Meal Prep', 'Knowledgeable in preparing nutritious meals for senior dietary needs.'),
('Personal Care Assistance', 'Experience assisting with bathing, grooming, and daily hygiene.'),
('Vital Signs Monitoring', 'Trained to monitor blood pressure, temperature, and other vital signs.'),
('Palliative Care', 'Provides comfort care for patients with chronic or terminal illnesses.'),
('Infection Control', 'Knowledge of hygiene, sanitation, and infection prevention protocols.'),
('Patient Advocacy', 'Ability to advocate for patient needs and coordinate care plans.'),
('Rehabilitation Support', 'Assists with physical therapy exercises and rehabilitation routines.'),
('Communication Skills', 'Strong verbal and non-verbal communication with seniors.'),
('Emotional Support', 'Provides companionship, emotional support, and mental stimulation.'),
('Wound Care', 'Trained to manage minor wounds and observe healing progress.'),
('Safety & Fall Prevention', 'Ensures a safe environment and reduces risk of falls.'),
('Alzheimer\'s Care', 'Specialized knowledge in caring for Alzheimer\'s patients.'),
('End-of-Life Care', 'Experience in providing comfort and dignity during end-of-life stages.'),
('Cognitive Stimulation', 'Ability to engage seniors in activities that maintain cognitive function.'),
('Transportation Assistance', 'Provides safe and reliable transport for appointments and errands.');

INSERT INTO service_caregiver_qualification (caregiver_qualification_id, service_id) VALUES
(1, 1), (2, 1), (3, 1),
(4, 2), (5, 2), (6, 2),
(7, 3), (8, 3), (9, 4), 
(10, 4), (11, 4), (12, 5), 
(13, 5), (14, 6), (15, 6), 
(16, 6), (17, 7), (18, 7),
(19, 8), (20, 8), (1, 9), 
(4, 9), (7, 9), (10, 10), 
(13, 10), (16, 10);


