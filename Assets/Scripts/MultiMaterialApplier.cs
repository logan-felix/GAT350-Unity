using UnityEngine;
using UnityEditor;

public class MultiMaterialApplier : Editor
{
    [MenuItem("Tools/Enable Multi-Object Material Assignment")]
    static void ApplyMaterialToAllSelected()
    {
        // Check if a material is selected in the Project view
        Material materialToApply = Selection.activeObject as Material;

        if (materialToApply == null)
        {
            Debug.LogWarning("Please select a material in the Project window before using this tool.");
            return;
        }

        // Iterate through all selected GameObjects
        foreach (GameObject obj in Selection.gameObjects)
        {
            Renderer renderer = obj.GetComponent<Renderer>();
            if (renderer != null)
            {
                Undo.RecordObject(renderer, "Assign Material to Multiple Objects");
                renderer.material = materialToApply;
            }
        }

        Debug.Log($"Material '{materialToApply.name}' assigned to {Selection.gameObjects.Length} objects.");
    }
}
