conference
==========

Unknown (will be known in some while) University Conference 2013
Website with only one purpose to accept registrants for conference and help operator manage their billing

### Team

 - Alexey Fedorov (Waterlink) - Backend Developer, QA
 - Maxim Baz (z0rch) - Frontend Developer
 - Galina Zaytseva - UI/UX

### Technologies

 - PHP/CodeIgniter for backend
 - coffee-script and jQuery for frontend
 - MySQL for DB backend
 - Bootstrap as CSS framework

### Vision

User finds himself at conference promo site. It has link (or big button, whatever) to register page.
Being interested he clicks it. There this project begins.

Register page must collect following user data:
 - Surname, name and patronymic
 - Email
 - Phone number
 - Presentation thesis (optional, if participant, not only listener)
Email and phone number must be unique.

Collected data stores in DB backend. Unique id generates for each user.
After that operator sees in admin application new registrants and sends to them messages with instruction on how to pay bill.

Once user pays bill, operator sees his id in clientbank application and searches by this id in admin application and marks this user as completely registered for conference.

Admin application is part of this project too.

### Goal

To make a stable and nice registration for conference in a short amount of time (1 month maximum).

### Global tasks

 1. Register application
     - create RESTfull backend for participant/listeners data
     - create UI/UX design for register page
     - create web-client application communicating with RESTfull backend and following UI/UX design
 2. Admin application
     - create in the same fashion as Register application, allow following:
         * authorization required
         * view list of registrants in reverse chronological order
         * filters for list view (registered, bill-sent, paid, has-thesis)
         * allow downloading thesis if applicable
         * allow changing state of participant forth and back (registered -> bill-sent -> paid)
 3. Tests (3rd in list, but first in todo)

