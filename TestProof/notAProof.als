one sig X 
{ val : Int } {}


pred propertyOnInteger[]
{
(all x : Int | (some y : Int | gt[y,x] and X.val = y)) 
}

check aProperty { propertyOnInteger[] } for 1 but 4 Int
