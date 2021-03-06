// Agent driver in project auction

/* Initial beliefs and rules
 * schedule form -> [ [ci, ti, di, xi, yi] | for all i in schedule ]
 *     onde : c = cliente
 *            t = instante real de atendimento
 *            d = instante desejado de atendimento
 * 			  x, y = posicao cartesiana de atendimento */

last_known_time(0).

/* Initial goals */

!start.

/* Plans */

+!start : true <- .df_register("driver").

+!vns_free : true
	<-	?schedule(Sch);
		?last_known_time(KT);
		jia.schedule_vns(Sch, KT, NewSch);
		-+schedule(NewSch);
		.at("now + 1 s", {+!vns_free});
		.

+!vns_block : true
	<-	.print("VNS bloqueado");
		.
		
+auction(St, X, Y, KT, DT)[source(A)] : true
	<-  ?schedule(Sch);
		jia.schedule_cost(Sch, St, X, Y, KT, DT, A, Result)
		.nth(0,Result,Bid_value);
		-+last_known_time(KT);
		.send(A,tell,bid(Bid_value));
		.
		
+winner(W)[source(A)] : .my_name(N) & N = W
	<-  ?auction(St, X, Y, _, DT)[source(A)];
		?last_known_time(KT);
		?schedule(Sch);
		jia.schedule_cost(Sch, St, X, Y, KT, DT, A, Result);		
		.nth(1,Result,New_Sch);
		.print(New_Sch);
		-+schedule(New_Sch);
		inc;
		.
		
+end[source(A)] : .my_name(N)
	<-	?schedule(Sch);
		jia.send_data(N,Sch);
		.send(A,tell,end_ok)
		.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
