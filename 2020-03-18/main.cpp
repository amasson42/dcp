
#include <iostream>

template <typename T>
class XorLinkedList {
    public:

    struct Node {
        T value;

        private:
        friend class XorLinkedList;
        Node *_both;
    };

    XorLinkedList() :
    _head(NULL),
    _tail(NULL) {
        
    }

    void add(Node *node) {
        node->_both = NULL;
        if (_head == NULL)
            _head = node;
        node->_both = _tail;
        _tail->_both = node ^ _tail;
        _tail = node;
    }

    Node* get(int index) {
        Node *prevId = NULL;
        Node *node = _head;
        for (int i = 0; i < index; i++) {
            Node *nextId = prevId ^ node->_both;
            if (nextId) {
                prevId = node;
                node = nextId;
            } else {
                return NULL;
            }
        }
        return node;
    }

    private:
    Node *_head;
    Node *_tail;
};

int main(void) {

    return 0;
}
