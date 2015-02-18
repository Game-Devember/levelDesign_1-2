#pragma strict
var health =100.0;

function Start () {

}

function Update () 
{
if(health<=0)
 Destroy(gameObject);
}
function OnTriggerEnter(other : Collider)
  {
   if(other.gameObject.tag==("Zombie"))
    {
     health-=25;
    }
  }
  