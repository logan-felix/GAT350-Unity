using UnityEngine;

public class MaterialController : MonoBehaviour
{
    [Range(0.1f, 0.5f)] public float bloat = 0;
    MeshRenderer meshRenderer;

    void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
    }

    void Update()
    {
        meshRenderer.material.SetFloat("_Bloat", bloat);
    }
}
