import { DialogSelect } from "../../ui/dialog-select"
import { useRoute } from "../../context/route"
import { zh } from "../../util/zh"

export function DialogSubagent(props: { sessionID: string }) {
  const route = useRoute()

  return (
    <DialogSelect
      title={zh("Subagent Actions")}
      options={[
        {
          title: zh("Open"),
          value: "subagent.view",
          description: zh("the subagent's session"),
          onSelect: (dialog) => {
            route.navigate({
              type: "session",
              sessionID: props.sessionID,
            })
            dialog.clear()
          },
        },
      ]}
    />
  )
}
