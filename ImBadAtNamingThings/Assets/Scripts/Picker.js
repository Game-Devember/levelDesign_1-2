#pragma strict

function Start () {

}

function Update () {

}
function OnTriggerEnter(other : Collider)
  {
   if(other.gameObject.tag == ("PickUp"))
    {
     Destroy(other.gameObject);
     CharacterMotorMovement.maxForwardSpeed +=10000;
     Debug.Log("0");
     yield WaitForSeconds(10);
     CharacterMotorMovement.maxForwardSpeed -=10000;
     Debug.Log("10");
    }
   }
     