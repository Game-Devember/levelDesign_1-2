#pragma strict
var carEntry:GameObject;
var carCamera :GameObject;
function Start () {



}

function Update () {

}
function OnTriggerEnter(other : Collider)
  {
   if(other.gameObject.tag == ("Car"))
    {
     Destroy(other.gameObject);
     carCamera.active = true;
     carEntry.active = true;
     carCamera.active = true;
     gameObject.active= false;
     
    }
   }
     