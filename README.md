Nederlands
==========
StwSim is een simulatie van een Nederlandse treindienstleidingspost.

Voor meer informatie: http://www.irespa.eu/stwsim/

English
=======
StwSim is a game which simulates the working place of a Dutch railway traffic controller. It includes functions such as the "process plan" which is used as input for automatic route setting. The program is designed to allow the use of data files containing different track layouts

More general information can be found at: http://www.irespa.eu/stwsim/

License
-------
© 2007-2014, Daan Goedkoop. All rights reserved.

General setup of the source code
--------------------------------
StwSim consists of two parts. On the one hand, there is the simulation of the physical infrastructure and trains. The accompanying code can be found in the files `src/stwp*.pas`. The other half of the program consists of the interlocking logic and its interface. This can be found in `src/stwv*.pas`.

Both parts communicate with eachother through text messages. They are exchanged via `serverSendMsg.pas` and `serverReadMsg.pas` on the side of the physical simulation, and `clientSendMsg.pas` and `clientReadMsg.pas` on the interlocking side.

Originally, both parts were accomodated in two different applications communicating through TCP/IP, in order to allow for multiplayer gaming. At the moment, this possibility is not used, though.

Types of units
--------------
Some units mainly contain data types, possibly implemented as classes that have some logic to internally update their own state information. These are units such as `stwpMonteur`, `stwpRails`, `stwpTreinen`, `stwvMeetpunt` and so on.

Then, there are the units containing further logic. Examples are `stwpTreinPhysics` containing the logic of driving trains and `stwpCore` containing much of the other logic of the physical simulation.

On the interlocking side, `stwvRijveiligheid` contains the actual interlockings; the functions that tell whether a certain action is permitted or not. `stwvRijwegLogica` builds upon this and contains the logic to actually set routes when they are considered permissible.

The communication system
------------------------
Phone conversations in the physical simulation are explicitly constructed as a finite-state machine. The states themselves are defined in `stwpTelefoongesprek.pas`, but the mechanisms for state transition are implemented in `stwpCommPhysics.pas`.

Locks
-----
The application contains `HandleMessage` in some places, especially during communication between both parts of the application. This leads to the possibility of asynchronous operation, which necessitates the use of locks to prevent race conditions.

There are two locks. One is in `stwvProcesplan.pas`, which makes sure that the automatic route setting will operate only on one rule at the same time within the plan for a specific area.

The second lock is in the interlocking itself. The unit in `stwvRijveiligheid.pas` contains the lock itself. Its safety-related functions always return `false` if the lock is set. The actual setting of the lock happens in `stwvRijwegLogica.pas`. In this unit, the usual procedure is that first a check is performed whether a certain operation is allowed, after which it is executed. The lock prevents that two conflicting actions are considered safe on their own and executed in parallel.