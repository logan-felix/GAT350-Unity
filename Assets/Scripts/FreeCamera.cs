using UnityEngine;

public class FreeCamera : MonoBehaviour
{
	public float moveSpeed = 10f;       // Movement speed
	public float lookSpeed = 2f;        // Mouse look sensitivity
	public float sprintMultiplier = 4f; // Speed multiplier when holding Shift
	public bool invertY = false;        // Option to invert Y axis

	private float yaw = 0f;
	private float pitch = 0f;

    private void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }

    void Update()
	{
		// Mouse look
		float mouseX = Input.GetAxis("Mouse X") * lookSpeed;
		float mouseY = Input.GetAxis("Mouse Y") * lookSpeed * (invertY ? 1 : -1);

		yaw += mouseX;
		pitch += mouseY;
		pitch = Mathf.Clamp(pitch, -90f, 90f); // Limit pitch to prevent flipping

		transform.eulerAngles = new Vector3(pitch, yaw, 0f);

		// Camera movement
		float speed = moveSpeed * (Input.GetKey(KeyCode.LeftShift) ? sprintMultiplier : 1f);

		Vector3 move = new Vector3(
			Input.GetAxis("Horizontal"), // A/D or Left/Right for side movement
			0,                           // Y-axis movement disabled by default
			Input.GetAxis("Vertical")    // W/S or Up/Down for forward/backward
		);

		// Allow up/down movement using Q/E keys
		if (Input.GetKey(KeyCode.Q)) move.y = -1;
		if (Input.GetKey(KeyCode.E)) move.y = 1;

		transform.Translate(move * speed * Time.deltaTime, Space.Self);
	}
}
