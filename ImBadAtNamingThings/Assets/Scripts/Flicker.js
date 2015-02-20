#pragma strict

function Start () {

}

function Update () {
if ( Random.value > 0.9 ) //a random chance
        {
           if ( light.enabled == true ) //if the light is on...
           {
             light.enabled = false; //turn it off
           }
           else
           {
             light.enabled = true; //turn it on
           }
        }

}