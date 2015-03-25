#pragma strict
var shotGun :GameObject;
var playerHealth=100;
function Start () {

}

function Update () 
{
//if(playerHealth<=0)
 //Destroy(gameObject);

}
function OnTriggerEnter(other : Collider)
  {
   if(other.gameObject.tag == ("PickUp"))
    { 
//     markers.active=true;
     Destroy(other.gameObject);
     CharacterMotorMovement.maxForwardSpeed +=20;
     CharacterMotorMovement.maxSidewaysSpeed+=20;
     CharacterMotorMovement.maxBackwardsSpeed+=20;
     CharacterMotorMovement.maxGroundAcceleration+=20;
     Debug.Log("0");
     
     yield WaitForSeconds(10);
    // markers.SetActive(false);
     CharacterMotorMovement.maxForwardSpeed -=20;
     CharacterMotorMovement.maxSidewaysSpeed -=20;
     CharacterMotorMovement.maxBackwardsSpeed -=20;
     CharacterMotorMovement.maxGroundAcceleration -=20;
     Debug.Log("10");
    }
   if(other.gameObject.tag==("healthPickUp"))
     {
      playerHealth=Mathf.Lerp(playerHealth,100,Time.deltaTime);
     }
     if(other.gameObject.tag==("shotGun"))
     {
      shotGun.SetActive(true);
     }
     if(other.gameObject.tag==("Zombie"))
    {
     playerHealth-=25;
    }
   }
     