// Agent client in project auction

/* Initial beliefs and rules */

/* Initial goals */

/* Plans */

+tick : true
	<-	?next(N);
		?queue_number(QN);
	   	if (N == QN) {
		   	.print("Iniciando");
		   	?service_point_x(X);
		   	?service_point_y(Y);
		   	?known_time(KT);
		   	?desired_time(DT);
		   	?service_type(ST)
		   	.broadcast(tell, auction(ST, X, Y, KT, DT));
		   	.at("now + 1 s", {+!decide}) 	   	
	   	}.
	   
+!decide : .findall(b(V,A), bid(V)[source(A)], L) &
           .length(L, N)
	<- 	if (N >= 1) {
			.min(L,b(V,W));
	    	.print("Winner is ", W, " with ", V);
	    	.broadcast(tell, winner(W));
	    	inc
		} else {
			.print("No response, giving up");
		}.


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }