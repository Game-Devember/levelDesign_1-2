#pragma strict
var SpawnPoint:Transform;
var markers :Transform;
function Start () {
yield WaitForSeconds(5);
transform.position=SpawnPoint.position;

}

function Update () {

}
function OnTriggerEnter(other : Collider)
  {
   if(other.gameObject.tag == ("PickUp"))
    { 
     markers.active=true;
     Destroy(other.gameObject);
     CharacterMotorMovement.maxForwardSpeed +=20;
     CharacterMotorMovement.maxSidewaysSpeed+=20;
     CharacterMotorMovement.maxBackwardsSpeed+=20;
     CharacterMotorMovement.maxGroundAcceleration+=20;
     Debug.Log("0");
     
     yield WaitForSeconds(10);
     markers.active=false;
     CharacterMotorMovement.maxForwardSpeed -=20;
     CharacterMotorMovement.maxSidewaysSpeed -=20;
     CharacterMotorMovement.maxBackwardsSpeed -=20;
     CharacterMotorMovement.maxGroundAcceleration -=20;
     Debug.Log("10");
    }
   }
     