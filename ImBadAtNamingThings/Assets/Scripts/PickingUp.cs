 using UnityEngine;
using System.Collections;

public class PickingUp : MonoBehaviour {

	// Use this for initialization
	void OnTriggerEnter(Collider other)
	{
	 if (other.gameObject.tag == "PickUp")
    	Destroy (other.gameObject);
	}
}
