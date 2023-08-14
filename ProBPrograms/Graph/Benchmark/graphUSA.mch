// copyright Richard St-Denis, Universite de Sherbrooke, 2023.
MODEL graphUSA

SETS
  Vertex = {AK, AL, AR, AZ, CA, CO, CT, DC, DE, FL,
            GA, HI, IA, ID, IL, IN_, KS, KY, LA, MA,
            MD, ME, MI, MN, MO, MS, MT, NC, ND, NE,
            NH, NJ, NM, NV, NY, OH, OK, OR_, PA, RI,
            SC, SD, TN, TX, UT, VA, VT, WA, WI, WV, WY}

DEFINITIONS
  "Theories/Fig9_graph.def";

CONSTANTS
  G,          // A graph
  v0          // The IN_itial vertex

PROPERTIES
  G = rec(vertices: Vertex,
          edges: SymClosure({(AL, FL), (AL, GA), (AL, MS), (AL, TN),
                   (AR, LA), (AR, MO), (AR, MS), (AR, OK), (AR, TN), (AR, TX),
                   (AZ, CA), (AZ, CO), (AZ, NM), (AZ, NV), (AZ, UT),
                   (CA, NV), (CA, OR_),
                   (CO, KS), (CO, NE), (CO, NM), (CO, OK), (CO, UT), (CO, WY),
                   (CT, MA), (CT, RI), (CT, NJ), (CT, NY),
                   (DC, MD), (DC, VA),
                   (DE, MD), (DE, NJ), (DE, PA),
                   (FL, GA),
                   (GA, NC), (GA, SC), (GA, TN),
                   (IA, MN), (IA, MO), (IA, NE), (IA, SD), (IA, WI),
                   (ID, MT), (ID, NV), (ID, OR_), (ID, UT), (ID, WA), (ID, WY),
                   (IL, IA), (IL, IN_), (IL, KY), (IL, MI), (IL, MO), (IL, WI),
                   (IN_, KY), (IN_, MI), (IN_, OH),(IN_, WI),
                   (KS, MS), (KS, NE), (KS, OK),
                   (KY, MO), (KY, OH), (KY, TN), (KY, VA), (KY, WV),
                   (LA, MS), (LA, OK), (LA, TX),
                   (MA, NH), (MA, NY), (MA, RI), (MA, VT),
                   (MD, NJ), (MD, PA), (MD, VA), (MD, WA),
                   (ME, MA), (ME, NH),
                   (MI, MN), (MI, NY), (MI, OH), (MI, PA), (MI, WI),
                   (MN, ND), (MN, SD), (MN, WI),
                   (MO, OK), (MO, NE), (MO, TN),
                   (MS, TN),
                   (MT, ND), (MT, SD), (MT, WY),
                   (NC, SC), (NC, TN), (NC, VA),
                   (ND, SD),
                   (NE, SD), (NE, WY),
                   (NH, VT),
                   (NJ, NY), (NJ, PA),
                   (NM, OK), (NM, TX), (NM, UT),
                   (NV, OR_), (NV, UT),
                   (NY, OH), (NY, PA), (NY, RI), (NY, VT),
                   (OH, PA), (OH, WV),
                   (OK, TX),
                   (OR_, WA),
                   (PA, VA), (PA, WV),
                   (SD, WY),
                   (TN, VA),
                   (UT, WY),
                   (VA, WV) }) ) &
  v0 = NY
END