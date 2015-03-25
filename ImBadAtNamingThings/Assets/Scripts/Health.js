#pragma strict
static  var playerHealth=100;

function Start () {

}

function Update () 
{
if(playerHealth<=0)
 Destroy(gameObject);
}
function OnTriggerEnter(other : Collider)
  {
   if(other.gameObject.tag==("Zombie"))
    {
     playerHealth-=25;
    }
  }
  