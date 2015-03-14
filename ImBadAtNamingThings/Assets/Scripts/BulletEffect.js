#pragma strict
var health=100;
function Start () {

}

function Update () {
if(health<=0)
Destroy(gameObject);

}
function TakeDamage()
 {
  health-=25;
  }