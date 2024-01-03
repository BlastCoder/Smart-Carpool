# Smart-Carpool

This project is an after-school dismissal management system. It is intended to speed up school deperatures to reduce the strain on traffic within the community while making the process more safer.

Machine Learning: We built a machine learning model to create a license-plate scanner to quickly send students outside
Google Firebase: We integrated the app with Google Firebase to provide instant connectivity for all users

Ways to Send Students Out:
- License Plate Scanner: Scan the license plate of a car, which is then encrypted using SHA-256 and sent to the database to be compared
    - The license plate scanner is built through a machine learning model
- QR Code Scanner: Scans a QR code created when adding the student to the database
    - Each student is assigned a unique QR code
- Manual: Teachers click on the students name to tell the supervisors inside the classroom to send the students out

To protect the identites of students, all of the data is encrypted using SHA-256 before being sent to the database
