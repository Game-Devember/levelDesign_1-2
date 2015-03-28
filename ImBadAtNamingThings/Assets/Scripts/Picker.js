#pragma strict
var shotGun :GameObject;
var zombies : GameObject;
var playerHealth=10;
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
      Destroy(other.gameObject);
      playerHealth=Mathf.Lerp(playerHealth,100,4);
      zombies.SetActive(true);
     }
     if(other.gameObject.tag==("shotGun"))
      
     {
      Destroy(other.gameObject);
      shotGun.SetActive(true);
     }
     if(other.gameObject.tag==("Zombie"))
    {
     playerHealth-=25;
    }
   }
     